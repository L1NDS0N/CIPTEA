import React, { Component } from 'react';
import { BrowserRouter, Switch, Route} from 'react-router-dom';


import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import New from './pages/New';
import Card from './pages/Card';
import CardPrinter from './pages/CardPrinter';

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
                <PrivateRoute exact path="/" component={Dashboard}/>
                <PrivateRoute exact path="/new" component={New}/>
                <PrivateRoute exact path="/card/:carteiraId" component={Card}/>
                <PrivateRoute exact path="/card/print/:carteiraId" component={CardPrinter}/>
            </Switch>
        </BrowserRouter>
    );
}
}
