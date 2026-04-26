const objectService = require("../services/objectService");
const jwt = require("jsonwebtoken");
const config = require("../config/config");
const response = require("../controllers/response.js");

class ObjectController {
    async getObjects(req, res) {
        try {
            await objectService.getObjects(req.params.page, res)
        } catch (error) {
            console.log(error)
        }
    }
    async getBannedObjects(req, res) {
        try {
            await objectService.getBannedObjects(req.params.page, res)
        } catch (error) {
            console.log(error)
        }
    }
    async getPlayerObjects(req, res) {
        try {
            await objectService.getPlayerObjects(req.params.page, req.params.id, res)

        } catch (error) {
            console.log(error)
        }
    }
    async getPartyObjects(req, res) {
        try {
            await objectService.getPartyObjects(req.params.page, req.params.id, res)
        } catch (error) {
            console.log(error)
        }
    }
    async getAvalibleObjects(req, res) {
        try {
            jwt.verify(req.body.user, config.secretKey, async (err, decoded) => {
                if (err) {
                    console.log(err.message)
                    if (err.message == "jwt expired") return res
                        .status(400)
                        .json(
                            response.error(
                                "invalid jwt",
                            ),
                        );
                    else return res.status(400).json(response.error("An error ocured with the login data",),);
                    return;
                }
                await objectService.getAvalibleObjects(req.params.page, decoded.sub, res)
            })
        } catch (error) {
            console.log(error)
        }
    }
    async getObject(req, res) {
        try {
            await objectService.getObject(req.params.id, res)
        } catch (error) {
            console.log(error)
        }
    }

}

module.exports = new ObjectController();