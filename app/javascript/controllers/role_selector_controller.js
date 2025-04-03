import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nameInput", "categorySelect"]

  addCustomRole(event) {
    event.preventDefault()
    const name = this.nameInputTarget.value.trim()
    const category = this.categorySelectTarget.value

    if (!name) return

    // 새로운 역할 체크박스 생성
    const categoryDiv = this.element.querySelector(`[data-category="${category}"]`)
    if (!categoryDiv) {
      // 새로운 카테고리 섹션 생성
      const newCategoryDiv = document.createElement('div')
      newCategoryDiv.className = 'mt-4'
      newCategoryDiv.setAttribute('data-category', category)
      
      const categoryTitle = document.createElement('h3')
      categoryTitle.className = 'text-sm font-medium text-gray-900'
      categoryTitle.textContent = category
      
      const rolesDiv = document.createElement('div')
      rolesDiv.className = 'grid'
      
      newCategoryDiv.appendChild(categoryTitle)
      newCategoryDiv.appendChild(rolesDiv)
      
      // 새로운 카테고리를 추가 버튼 위에 삽입
      const addButton = this.element.querySelector('button[data-action="role-selector#addCustomRole"]')
      addButton.parentElement.parentElement.parentElement.insertBefore(newCategoryDiv, addButton.parentElement.parentElement)
    }
    
    const rolesContainer = categoryDiv ? 
      categoryDiv.querySelector('.grid') : 
      this.element.querySelector(`[data-category="${category}"] .grid`)

    const roleDiv = document.createElement('div')
    roleDiv.className = 'relative flex items-start'
    roleDiv.innerHTML = `
      <div class="flex items-center h-5">
        <input type="checkbox" name="user[role_ids][]" value="custom_role_${Date.now()}" 
               class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded" checked>
        <input type="hidden" name="user[custom_roles][][name]" value="${name}">
        <input type="hidden" name="user[custom_roles][][category]" value="${category}">
      </div>
      <div class="ml-3 text-sm">
        <label class="font-medium text-gray-700">${name}</label>
      </div>
    `

    rolesContainer.appendChild(roleDiv)

    // 입력 필드 초기화
    this.nameInputTarget.value = ''

    // 카테고리 선택 옵션에 새 카테고리 추가
    const categoryOptions = Array.from(this.categorySelectTarget.options).map(opt => opt.value)
    if (!categoryOptions.includes(category)) {
      const option = document.createElement('option')
      option.value = category
      option.textContent = category
      this.categorySelectTarget.add(option)
    }
  }
}
