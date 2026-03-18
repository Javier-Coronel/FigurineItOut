const partyService = require("../services/partyService");

class PartyController {
    async createParty(req, res){
        console.log(req)
        return await partyService.createParty(req.body,res)
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
    async addUserToParty(user, party){
        try {
            
            await partyService.addUser(req.body,res)
        } catch (error) {
            
        }
    }

}

module.exports = new PartyController();