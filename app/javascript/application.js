// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Stimulus 설정
import { Application } from "@hotwired/stimulus"
window.Stimulus = Application.start()

// Devise 폼 제출 시 Turbo 비활성화
document.addEventListener("turbo:load", () => {
  const forms = document.querySelectorAll("form[data-turbo='false']")
  forms.forEach(form => {
    form.setAttribute("data-turbo", "false")
    // 폼 제출 시 기본 동작 사용
    form.addEventListener("submit", () => {
      Turbo.navigator.submitForm(form)
    })
  })
})
