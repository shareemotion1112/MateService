class ChangeTeamMemberStatusToInteger < ActiveRecord::Migration[7.1]
  def up
    # 임시 컬럼 추가
    add_column :team_members, :status_integer, :integer

    # 기존 데이터 변환
    TeamMember.reset_column_information
    TeamMember.find_each do |member|
      case member.status
      when 'pending'
        member.update_column(:status_integer, 0)
      when 'active'
        member.update_column(:status_integer, 1)
      when 'inactive'
        member.update_column(:status_integer, 2)
      end
    end

    # 기존 컬럼 삭제 및 새 컬럼 이름 변경
    remove_column :team_members, :status
    rename_column :team_members, :status_integer, :status
  end

  def down
    # 임시 컬럼 추가
    add_column :team_members, :status_string, :string

    # 기존 데이터 변환
    TeamMember.reset_column_information
    TeamMember.find_each do |member|
      case member.status
      when 0
        member.update_column(:status_string, 'pending')
      when 1
        member.update_column(:status_string, 'active')
      when 2
        member.update_column(:status_string, 'inactive')
      end
    end

    # 기존 컬럼 삭제 및 새 컬럼 이름 변경
    remove_column :team_members, :status
    rename_column :team_members, :status_string, :status
  end
end
