# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120706205126) do

  create_table "elections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "results", :force => true do |t|
    t.string   "tik_name"
    t.string   "uik_name"
    t.integer  "tik_id"
    t.integer  "uik_id"
    t.integer  "election_id"
    t.string   "vote_date"
    t.text     "cost_report"
    t.float    "percentage_10"
    t.float    "percentage_12"
    t.float    "percentage_15"
    t.float    "percentage_18"
    t.text     "percentage_text"
    t.text     "results_text"
    t.integer  "r1_voters_in_list"
    t.integer  "r2_ballots_received"
    t.integer  "r3_ballots_pre"
    t.integer  "r4_ballots_handed_at_station"
    t.integer  "r5_ballots_handed_outside_station"
    t.integer  "r6_ballots_canceled"
    t.integer  "r7_ballots_in_mobile_boxes"
    t.integer  "r8_ballots_in_stationary_boxes"
    t.integer  "r9_ballots_invalid"
    t.integer  "r10_ballots_valid"
    t.integer  "r11_unattach_cert_received"
    t.integer  "r12_unattach_cert_handed"
    t.integer  "r13_voted_with_unattach_cert"
    t.integer  "r14_unattach_cert_unused"
    t.integer  "r15_unattach_cert_handed_by_tik"
    t.integer  "r16_unattach_cert_lost"
    t.integer  "r17_ballots_lost"
    t.integer  "r18_ballots_not_known_initially"
    t.integer  "r19_data1"
    t.integer  "r20_data2"
    t.integer  "r21_data3"
    t.integer  "r22_data4"
    t.integer  "r23_data5"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "tiks", :force => true do |t|
    t.integer "num"
    t.string  "name"
  end

  create_table "uiks", :force => true do |t|
    t.integer  "num"
    t.integer  "tik_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
