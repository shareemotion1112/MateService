// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import RoleSelectorController from "./role_selector_controller"
application.register("role-selector", RoleSelectorController)

import SkillSelectorController from "./skill_selector_controller"
application.register("skill-selector", SkillSelectorController)
