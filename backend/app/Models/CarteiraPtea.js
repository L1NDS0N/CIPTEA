/** @type {typeof import('@adonisjs/lucid/src/Lucid/Model')} */
const Model = use('Model');

const Env = use('Env');

class CarteiraPtea extends Model {
  static get computed() {
    return ['fotoRostoPath_url'];
  }

  usuarioRecepcionista() {
    return this.belongsTo('App/Models/User', 'usuarioRecepcionista_id', 'id');
  }

  getFotoRostoUrl({ fotoRostoPath }) {
    const url = `${Env.get('APP_URL')}/files/${fotoRostoPath}`;
    console.log(url);
    return url;
  }
}

module.exports = CarteiraPtea;
