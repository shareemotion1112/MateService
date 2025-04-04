class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills
  has_many :project_skills, dependent: :destroy
  has_many :projects, through: :project_skills

  validates :name, presence: true, uniqueness: true

  # 기본 기술 스택 카테고리
  CATEGORIES = {
    backend: [ "Ruby", "Python", "Java", "PHP", "Node.js", "Go", "C#", ".NET" ],
    frontend: [ "JavaScript", "TypeScript", "React", "Vue.js", "Angular", "Svelte", "HTML", "CSS" ],
    mobile: [ "iOS", "Android", "React Native", "Flutter", "Swift", "Kotlin" ],
    database: [ "MySQL", "PostgreSQL", "MongoDB", "Redis", "SQLite", "Oracle", "SQL Server" ],
    devops: [ "AWS", "GCP", "Azure", "Docker", "Kubernetes", "Jenkins", "Git", "Linux" ],
    ai_ml: [ "TensorFlow", "PyTorch", "scikit-learn", "OpenCV", "NLP", "Computer Vision" ],
    design: [ "Figma", "Adobe XD", "Sketch", "Photoshop", "Illustrator", "After Effects" ],
    etc: [ "기타" ]
  }
end
