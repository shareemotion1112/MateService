# 기본 역할 생성
Role::CATEGORIES.each do |category_key, category_name|
  Role::DEFAULTS[category_key].each do |role_name|
    Role.find_or_create_by!(name: role_name, category: category_name)
  end
end

# 기본 기술 스택 생성
Skill::CATEGORIES.each do |category_key, skills|
  skills.each do |skill_name|
    Skill.find_or_create_by!(name: skill_name, category: category_key.to_s)
  end
end
