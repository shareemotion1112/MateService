class ChangeProjectStatusToInteger < ActiveRecord::Migration[8.0]
  def up
    # 임시 컬럼 추가
    add_column :projects, :status_integer, :integer

    # 기존 데이터 변환
    execute <<-SQL
      UPDATE projects
      SET status_integer = CASE status
        WHEN 'idea' THEN 0
        WHEN 'planning' THEN 1
        WHEN 'development' THEN 2
        WHEN 'launched' THEN 3
        ELSE 0
      END;
    SQL

    # 기존 컬럼 삭제
    remove_column :projects, :status

    # 새 컬럼 이름 변경
    rename_column :projects, :status_integer, :status

    # 기본값 설정
    change_column_default :projects, :status, 0
  end

  def down
    # 임시 컬럼 추가
    add_column :projects, :status_string, :string

    # 기존 데이터 변환
    execute <<-SQL
      UPDATE projects
      SET status_string = CASE status
        WHEN 0 THEN 'idea'
        WHEN 1 THEN 'planning'
        WHEN 2 THEN 'development'
        WHEN 3 THEN 'launched'
        ELSE 'idea'
      END;
    SQL

    # 기존 컬럼 삭제
    remove_column :projects, :status

    # 새 컬럼 이름 변경
    rename_column :projects, :status_string, :status

    # 기본값 설정
    change_column_default :projects, :status, 'idea'
  end
end
