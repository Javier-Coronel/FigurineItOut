const userService = require("../services/userService");

class UserController {
    async signin(req, res){
        try {
            userService.signin(req, res)
        } catch (error) {
            
        }
    }
    async signout(req, res){
        try {
            userService.signout(req, res)
        } catch (error) {
            
        }
    }
    
    async getAllUsers(req, res){
        try {
            
        } catch (error) {
            
        }
    }
    async getUserById(req, res){
        try {
            
        } catch (error) {
            
        }
    }
    async updatePassword(req, res){
        try {
            
        } catch (error) {
            
        }
    }
    async deleteUser(req, res){
        try {
            
        } catch (error) {
            
        }
    }
}

module.exports = new UserController();