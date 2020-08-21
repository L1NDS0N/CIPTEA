const CarteiraPtea = use('App/Models/CarteiraPtea');
/** @typedef {import('@adonisjs/framework/src/Request')} Request */
/** @typedef {import('@adonisjs/framework/src/Response')} Response */
/** @typedef {import('@adonisjs/framework/src/View')} View */

/**
 * Resourceful controller for interacting with carteirapteas
 */
class CarteiraPteaController {
  /**
   * Show a list of all carteirapteas.
   * GET carteirapteas
   *
   * @param {object} ctx
   * @param {Request} ctx.request
   * @param {Response} ctx.response
   * @param {View} ctx.view
   */
  async index() {
    const carteiras = await CarteiraPtea.query()
      .with('usuarioRecepcionista', (builder) => {
        builder.select(['id', 'nomeCompleto', 'matricula']);
      })
      .fetch();

    return carteiras;
  }

  /**
   * Render a form to be used for creating a new carteiraptea.
   * GET carteirapteas/create
   *
   * @param {object} ctx
   * @param {Request} ctx.request
   * @param {Response} ctx.response
   * @param {View} ctx.view
   */
  async create() {}

  /**
   * Create/save a new carteiraptea.
   * POST carteirapteas
   *
   * @param {object} ctx
   * @param {Request} ctx.request
   * @param {Response} ctx.response
   */
  async store({ request, auth }) {
    const data = request.all();

    const carteira = await CarteiraPtea.create({
      usuarioRecepcionista_id: auth.user.id,
      ...data,
    });

    return carteira;
  }

  /**
   * Display a single carteiraptea.
   * GET carteirapteas/:id
   *
   * @param {object} ctx
   * @param {Request} ctx.request
   * @param {Response} ctx.response
   * @param {View} ctx.view
   */
  async show({ params }) {
    const carteira = await CarteiraPtea.findOrFail(params.id);

    return carteira;
  }

  /**
   * Render a form to update an existing carteiraptea.
   * GET carteirapteas/:id/edit
   *
   * @param {object} ctx
   * @param {Request} ctx.request
   * @param {Response} ctx.response
   * @param {View} ctx.view
   */
  async edit() {}

  /**
   * Update carteiraptea details.
   * PUT or PATCH carteirapteas/:id
   *
   * @param {object} ctx
   * @param {Request} ctx.request
   * @param {Response} ctx.response
   */
  async update() {}

  /**
   * Delete a carteiraptea with id.
   * DELETE carteirapteas/:id
   *
   * @param {object} ctx
   * @param {Request} ctx.request
   * @param {Response} ctx.response
   */
  async destroy({ params }) {
    const carteira = await CarteiraPtea.findOrFail(params.id);

    await carteira.delete();
  }
}

module.exports = CarteiraPteaController;
