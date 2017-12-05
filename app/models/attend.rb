class Attend < ApplicationRecord
  enum status: %w(attendance late absent)

  belongs_to :rocket_member

  def self.attend_members_count(date)
    self.where(date: date).where(status: "attendance").count
  end

  def self.lated_members_count(date)
    self.where(date: date).where(status: "late").count
  end

  def self.status_of_attendance(date, member)
    if self.where(date: date).where(rocket_member_id: member).present?
      if self.where(date: date).where(rocket_member_id: member).take.status == "attendance"
        return 0
      elsif self.where(date: date).where(rocket_member_id: member).take.status == "late"
        return 1
      else
        return 2
      end
    else
      return 3
    end
  end

  def self.score(start_date, end_date, member)
    self.where(rocket_member_id: member).where("date >= ?", start_date).where("date < ?", end_date).where(status: 0).count + self.where(rocket_member_id: member).where("date >= ?", start_date).where("date < ?", end_date).where(status: 1).count * 0.5
  end
end
