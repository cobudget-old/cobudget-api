class AddJobIdsToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :round_open_mailer_job_id, :integer
    add_column :rounds, :round_closed_mailer_job_id, :integer
  end
end
