import React, { Component } from 'react';
import { BrowserRouter, Switch, Route} from 'react-router-dom';


import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import New from './pages/New';

import { PrivateRoute } from './helpers/PrivateRoute';

export default class Routes extends Component {
    
    constructor(props){
        super(props);
        this.state = { value: ""}
    }

    render() {
    return (
        <BrowserRouter>
            <Switch>
                {/* Vide: Autenticação para rotas */}
                <Route exact path="/login" component={Login}/>
                <PrivateRoute exact path="/dashboard" component={Dashboard}/>
                <PrivateRoute path="/new" component={New}/>
            </Switch>
        </BrowserRouter>
    );
}
}
