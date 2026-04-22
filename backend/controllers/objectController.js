const objectService = require("../services/objectService");

class ObjectController {
    async getObjects(req, res){
        try{
            await objectService.getObjects( req.params.page, res)
        }catch(error){
            console.log(error)
        }
    }
    async getBannedObjects(req, res){
        try{
            await objectService.getBannedObjects( req.params.page, res)
        }catch(error){
            console.log(error)
        }
    }
    async getPlayerObjects(req, res){
        try{
            await objectService.getPlayerObjects( req.params.page, req.params.id, res)
            
        }catch(error){
            console.log(error)
        }
    }
    async getPartyObjects(req, res){
        try{
            await objectService.getPartyObjects( req.params.page, req.params.id, res)
        }catch(error){
            console.log(error)
        }
    }
    async getAvalibleObjects(req, res){
        try{
            await objectService.getAvalibleObjects( req.params.page, req.params.id, res)
        }catch(error){
            console.log(error)
        }
    }
    async getObject(req, res){
        try{
            await objectService.getObject( req.params.id, res)
        }catch(error){
            console.log(error)
        }
    }

}

module.exports = new ObjectController();