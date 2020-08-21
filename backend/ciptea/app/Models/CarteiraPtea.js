/** @type {typeof import('@adonisjs/lucid/src/Lucid/Model')} */
const Model = use('Model');

class CarteiraPtea extends Model {
  usuarioRecepcionista() {
    return this.belongsTo('App/Models/User', 'usuarioRecepcionista_id', 'id');
  }
}

module.exports = CarteiraPtea;
