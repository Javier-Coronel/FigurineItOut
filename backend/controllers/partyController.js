const partyService = require("../services/partyService");

class PartyController {
    async createParty(){
        return await partyService.createParty()
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
            
            await partyService.addUserToParty(user, party)
        } catch (error) {
            console.log(error)
        }
    }

}

module.exports = new PartyController();