class Result < ActiveRecord::Base
  attr_accessible :cost_report, :election_id, :percentage_10, :percentage_12, :percentage_15, :percentage_18, :percentage_text, :r10_ballots_valid, :r11_unattach_cert_received, :r12_unattach_cert_handed, :r13_voted_with_unattach_cert, :r14_unattach_cert_unused, :r15_unattach_cert_handed_by_tik, :r16_unattach_cert_lost, :r17_ballots_lost, :r18_ballots_not_known_initially, :r19_data1, :r1_voters_in_list, :r20_data2, :r21_data3, :r22_data4, :r23_data5, :r2_ballots_received, :r3_ballots_pre, :r4_ballots_handed_at_station, :r5_ballots_handed_outside_station, :r6_ballots_canceled, :r7_ballots_in_mobile_boxes, :r8_ballots_in_stationary_boxes, :r9_ballots_invalid, :results_text, :tik_id, :tik_name, :uik_id, :uik_name, :vote_date
  
  belongs_to :uik
  belongs_to :tik
  belongs_to :election
end
