/*
|--------------------------------------------------------------------------
| Routes
|--------------------------------------------------------------------------
|
| Http routes are entry points to your web application. You can create
| routes for different URLs and bind Controller actions to them.
|
| A complete guide on routing is available here.
| http://adonisjs.com/docs/4.1/routing
|
*/

/** @type {typeof import('@adonisjs/framework/src/Route/Manager')} */
const Route = use('Route');

Route.get('/files/:file', 'FileController.show');
Route.post('/register', 'AuthController.register');
Route.post('/authenticate', 'AuthController.authenticate').validator('Auth');

Route.post('/forgot', 'ForgotPasswordController.store').validator('Forgot');
Route.post('/reset', 'ResetPasswordController.store').validator('Reset');

Route.get('/app', 'AppController.index').middleware(['auth']);

// Cadastro de carteira
Route.group(() => {
  Route.resource('carteiras', 'CarteiraPteaController')
    .apiOnly()
    .except('update');
}).middleware('auth');
