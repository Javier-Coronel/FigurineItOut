
module.exports = {
    exito: (data, message = 'Operation succesfull.') => ({
      ok: true,
      data: data,
      message: message,
    }),
  
    error: (message = 'There was an erron on the server.') => ({
      ok: false,
      data: null,
      message: message,
    }),
  };