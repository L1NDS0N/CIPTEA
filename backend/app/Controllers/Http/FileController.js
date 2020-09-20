'use strict'
// tenho que checar se os helpers estão instalados
/** @type {import('@adonisjs/ignitor/src/Helpers')} */
const Helpers = use('Helpers');

class FileController {
  async show({ params, response }) {
    return response.download(Helpers.tmpPath(`uploads/${params.file}`));
  }
}

module.exports = FileController;
