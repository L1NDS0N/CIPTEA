import React from 'react';

import './App.css'
import Routes from './routes';
import logo from './assets/logo.svg'


function App() { 

    return ( 
    <div className="container">
        <img src={ logo }
            id="logo"
            alt="CipteaLogo"/>
            <h1 className="title">CIPTEA</h1>
            <p className="subtitle">
            Carteira de Identificação da Pessoa com Espectro Autista
            </p>

        <div className="content">
            <Routes />
            </div> 
            <footer>
            <p className="devCredits" >
            Developed and distruted by <a 
                href="https://github.com/l1nds0n/"
                target="_blank"
                rel="noopener noreferrer">
           <strong> L1NDS0N © 2020 </strong>
            </a>
            </p> 
            <p className="imageCredits" >
            Imagem por <a 
                href="https://wendelljefferson.com.br/"
                target="_blank"
                rel="noopener noreferrer" >
           <strong> Wendell Jefferson  </strong>
            </a> 
            </p> 
        </footer>
    </div>
    );
    }

export default App;