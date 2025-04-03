import { Controller } from "@hotwired/stimulus"

// Skill selector controller
export default class extends Controller {
  static targets = ["input", "selectedSkills"]

  initialize() {
    console.log("Skill selector controller initialized")
  }

  connect() {
    console.log("Skill selector controller connected")
    console.log("Input target:", this.inputTarget)
    console.log("Selected skills target:", this.selectedSkillsTarget)
    // 엔터 키 이벤트 리스너 추가
    this.inputTarget.addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        event.preventDefault()
        this.addSkill(event)
      }
    })
  }

  disconnect() {
    // 컨트롤러가 해제될 때 이벤트 리스너 제거
    this.inputTarget.removeEventListener("keydown", this.handleEnterKey)
  }

  async addSkill(event) {
    event.preventDefault()
    console.log("Add skill button clicked")
    
    const skillName = this.inputTarget.value.trim()
    if (!skillName) {
      console.log("No skill name provided")
      return
    }
    
    console.log(`Adding skill: ${skillName}`)
    
    try {
      // 기술 스택 생성 요청
      const response = await fetch('/skills', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ skill: { name: skillName } })
      })
      
      if (!response.ok) {
        throw new Error('Failed to create skill')
      }
      
      const skill = await response.json()
      
      const html = `
        <span class="inline-flex items-center px-3 py-0.5 rounded-full text-sm font-medium bg-indigo-100 text-indigo-800">
          ${skillName}
          <button type="button" data-action="skill-selector#removeSkill" class="ml-1.5 inline-flex items-center justify-center h-4 w-4 rounded-full text-indigo-400 hover:bg-indigo-200 hover:text-indigo-500 focus:outline-none">
            <span class="sr-only">Remove skill</span>
            <svg class="h-3 w-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
          </button>
          <input type="hidden" name="user[skill_ids][]" value="${skill.id}">
        </span>
      `
      
      this.selectedSkillsTarget.insertAdjacentHTML('beforeend', html)
      this.inputTarget.value = ''
      console.log("Skill added successfully")
    } catch (error) {
      console.error("Error adding skill:", error)
      alert("기술 스택 추가에 실패했습니다.")
    }
  }

  removeSkill(event) {
    event.preventDefault()
    console.log("Remove skill button clicked")
    const skillElement = event.currentTarget.closest('span')
    const skillName = skillElement.textContent.trim()
    console.log(`Removing skill: ${skillName}`)
    skillElement.remove()
    console.log("Skill removed successfully")
  }
}
