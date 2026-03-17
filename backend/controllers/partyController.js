const partyService = require("../services/partyService");

class PartyController {
    async createParty(req, res){
        console.log(req)
        await partyService.createParty(req.body,res)
    }
    async getAllPartys(req, res){
        try {
            
        } catch (error) {
            
        }
    }
    async getPartyById(req, res){
        try {
            
        } catch (error) {
            
        }
    }
    async addUserToParty(req, res){
        try {
            
            await partyService.createParty(req.body,res)
        } catch (error) {
            
        }
    }

}

module.exports = new PartyController();