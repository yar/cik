require "iconv"

class Election < ActiveRecord::Base
  attr_accessible :name
  
  has_many :results
  
  def self.scrape
    election = Election.where(:name => "Выборы Президента Российской Федерации 04.03.2012").first_or_create
    election.scrape
  end
  
  def scrape
    @agent = Mechanize.new
    main_index = @agent.get "http://www.tatarstan.vybory.izbirkom.ru/region/tatarstan?action=show&root_a=162000035&vrn=100100031793505&region=16&global=true&type=0&root=1000035&prver=0&pronetvd=null&tvd=100100031793884"
    nav_form = main_index.form "go_reg"
    nav_form.field_with(:name => "gs").options.each_with_index do |option, i|
      if option.value =~ /^http/
        option.text =~ /(\d+) (.*)/
        tik_num = $1
        tik_name = $2
        
        tik = Tik.where(:num => tik_num).first_or_create(:name => tik_name)
        raise "Reused tiks num" if tik.name != tik_name
        
        puts "Scraping TIK #{tik_num} '#{tik_name}'"
        scrape_tik(option.value, tik)
      end
      
      # break if i > 3
      # sleep 0.5
    end
  end
  
  def scrape_tik(link, tik)
    tik_index = @agent.get link
    
    nav_form = tik_index.form "go_reg"
    nav_form.field_with(:name => "gs").options.each_with_index do |option, i|
      if option.value =~ /^http/
        option.text =~ /\D(\d+)$/
        uik_num = $1
        
        uik = tik.uiks.where(:num => uik_num).first_or_create
        
        puts "Scraping UIK #{uik_num}"
        scrape_uik(option.value, uik)
      end

      # break if i > 3
      # sleep 0.5
    end
  end

  def scrape_uik(link, uik)
    result = uik.results.where(:election_id => self.id).first_or_initialize(:tik_id => uik.tik.id)

    uik_index_page = @agent.get link
    
    cost_url_str = uik_index_page.link_with(:text => 'Отчет ЦИК России о расходовании средств федерального бюджета, выделенных на подготовку и проведение выборов').href
    cost_url_str =~ /'(http.*)'/
    cost_url = $1
    
    percentage_url = uik_index_page.link_with(:text => 'Предварительные сведения об участии избирателей в выборах').href
    data_url = uik_index_page.link_with(:text => 'Итоги голосования').href
    
    cost_page = @agent.get cost_url    
    result.cost_report = Iconv.conv("UTF-8", "CP1251", cost_page.body)
    
    percentage_page = @agent.get percentage_url
    result.percentage_text = Iconv.conv("UTF-8", "CP1251", percentage_page.body)
    
    header = percentage_page.search("[text()*='Итого']").first
    result.percentage_10 = header.parent.next_element.text.strip.gsub("%", "").to_f
    result.percentage_12 = header.parent.next_element.next_element.text.strip.gsub("%", "").to_f
    result.percentage_15 = header.parent.next_element.next_element.next_element.text.strip.gsub("%", "").to_f
    result.percentage_18 = header.parent.next_element.next_element.next_element.next_element.text.strip.gsub("%", "").to_f
        
    data_page = @agent.get data_url
    result.results_text = Iconv.conv("UTF-8", "CP1251", data_page.body)
    
    fields = {
      :r1_voters_in_list => 'Число избирателей, включенных в список избирателей',
      :r2_ballots_received => 'Число избирательных бюллетеней, полученных участковой избирательной комиссией',
      :r3_ballots_pre => 'Число избирательных бюллетеней, выданных избирателям, проголосовавшим досрочно',
      :r4_ballots_handed_at_station => 'Число избирательных бюллетеней, выданных в помещении для голосования в день голосования',
      :r5_ballots_handed_outside_station => 'Число избирательных бюллетеней, выданных вне помещения для голосования в день голосования',
      :r6_ballots_canceled => 'Число погашенных избирательных бюллетеней',
      :r7_ballots_in_mobile_boxes => 'Число избирательных бюллетеней в переносных ящиках для голосования',
      :r8_ballots_in_stationary_boxes => 'Число бюллетеней в стационарных ящиках для голосования',
      :r9_ballots_invalid => 'Число недействительных избирательных бюллетеней',
      :r10_ballots_valid => 'Число действительных избирательных бюллетеней',
      :r11_unattach_cert_received => 'Число полученных открепительных  удостоверений',
      :r12_unattach_cert_handed => 'Число открепительных удостоверений, выданных избирателям на избирательном участке',
      :r13_voted_with_unattach_cert => 'Число избирателей, проголосовавших по открепительным удостоверениям',
      :r14_unattach_cert_unused => 'Число неиспользованных открепительных удостоверений',
      :r15_unattach_cert_handed_by_tik => 'Число открепительных удостоверений, выданных избирателям ТИК',
      :r16_unattach_cert_lost => 'Число утраченных открепительных удостоверений',
      :r17_ballots_lost => 'Число утраченных избирательных бюллетеней',
      :r18_ballots_not_known_initially => 'Число избирательных бюллетеней, не учтенных при получении',
      :r19_data1 => 'Жириновский Владимир Вольфович',
      :r20_data2 => 'Зюганов Геннадий Андреевич',
      :r21_data3 => 'Миронов Сергей Михайлович',
      :r22_data4 => 'Прохоров Михаил Дмитриевич',
      :r23_data5 => 'Путин Владимир Владимирович'
    }
    
    fields.each do |field, name|
      header = data_page.search("[text()*='#{name}']").first
      begin
        val = header.next_element.text
      rescue NoMethodError
        raise "NoMethodError while looking for '#{name}'"
      end
      if field.to_s =~ /_data/
        val = header.next_element.children.first.text
      end
      
      result[field] = val
    end
    
    result.save!
  end
end
