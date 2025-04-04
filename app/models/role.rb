class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  validates :name, presence: true
  validates :category, presence: true

  # 기본 역할 카테고리
  CATEGORIES = {
    technical: "기술",
    business: "사업",
    design: "디자인",
    marketing: "마케팅",
    planning: "기획",
    hr: "인사",
    other: "기타"
  }

  # 기본 역할들
  DEFAULTS = {
    technical: [ "백엔드 개발자", "프론트엔드 개발자", "풀스택 개발자", "모바일 개발자", "데브옵스 엔지니어" ],
    business: [ "CEO", "사업개발", "영업", "투자" ],
    design: [ "UI/UX 디자이너", "그래픽 디자이너", "제품 디자이너" ],
    marketing: [ "마케터", "콘텐츠 크리에이터", "브랜드 매니저" ],
    planning: [ "기획자", "프로덕트 매니저", "서비스 기획자" ],
    hr: [ "인사 담당자", "채용 담당자", "교육 담당자" ],
    other: [ "기타" ]
  }

  # 모든 카테고리 가져오기 (기본 + 커스텀)
  def self.all_categories
    distinct.pluck(:category)
  end

  # 카테고리별로 역할 그룹화
  def self.group_by_categories
    all.group_by(&:category)
  end

  # 카테고리 검증에서 커스텀 카테고리 허용
  def self.categories
    CATEGORIES.values
  end

  # 카테고리 이름으로 키 찾기 (없으면 other 반환)
  def self.category_key(category_name)
    CATEGORIES.key(category_name) || :other
  end

  # 기본 역할 생성
  def self.create_defaults
    CATEGORIES.each do |key, category|
      DEFAULTS[key].each do |name|
        find_or_create_by!(name: name, category: category)
      end
    end
  end
end
