class ChangeTeamMemberRoleToInteger < ActiveRecord::Migration[7.1]
  def up
    # 임시 컬럼 추가
    add_column :team_members, :role_integer, :integer

    # 기존 데이터 변환
    TeamMember.reset_column_information
    TeamMember.find_each do |member|
      case member.role
      when 'founder'
        member.update_column(:role_integer, 0)
      when 'co-founder'
        member.update_column(:role_integer, 1)
      when 'developer'
        member.update_column(:role_integer, 2)
      when 'designer'
        member.update_column(:role_integer, 3)
      when 'planner'
        member.update_column(:role_integer, 4)
      when 'marketer'
        member.update_column(:role_integer, 5)
      when 'other'
        member.update_column(:role_integer, 6)
      when 'advisor'
        member.update_column(:role_integer, 7)
      when 'investor'
        member.update_column(:role_integer, 8)
      end
    end

    # 기존 컬럼 삭제 및 새 컬럼 이름 변경
    remove_column :team_members, :role
    rename_column :team_members, :role_integer, :role
  end

  def down
    # 임시 컬럼 추가
    add_column :team_members, :role_string, :string

    # 기존 데이터 변환
    TeamMember.reset_column_information
    TeamMember.find_each do |member|
      case member.role
      when 0
        member.update_column(:role_string, 'founder')
      when 1
        member.update_column(:role_string, 'co-founder')
      when 2
        member.update_column(:role_string, 'developer')
      when 3
        member.update_column(:role_string, 'designer')
      when 4
        member.update_column(:role_string, 'planner')
      when 5
        member.update_column(:role_string, 'marketer')
      when 6
        member.update_column(:role_string, 'other')
      when 7
        member.update_column(:role_string, 'advisor')
      when 8
        member.update_column(:role_string, 'investor')
      end
    end

    # 기존 컬럼 삭제 및 새 컬럼 이름 변경
    remove_column :team_members, :role
    rename_column :team_members, :role_string, :role
  end
end
