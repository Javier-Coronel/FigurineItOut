const playerService = require("../services/playerService");

class PlayerController {
    async createPlayer(req, res){
        await playerService.createPlayer(req.body,res)
    }
    async getAllPlayers(req, res){
        try {
            
        } catch (error) {
            
        }
    }
    async getPlayerById(req, res){
        try {
            
        } catch (error) {
            
        }
    }
    async banPlayer(req, res){
        try {
            
        } catch (error) {
            
        }
    }

}

module.exports = new PlayerController();