class Auth {
  get rules() {
    return {
      email: 'email|required',
      password: 'required',
    };
  }
}

module.exports = Auth;
