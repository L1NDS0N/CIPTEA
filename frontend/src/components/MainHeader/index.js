import React from 'react';

import logo from '../../assets/logo.svg'
import './styles.css';

export default function MainHeader() {

    return (
        <>
            <div id="MainHeader">
                <div id="MHContent">
                    <a href="/">
                        <img
                            src={logo}
                            id="logo"
                            alt="CipteaLogo" />
                    </a>

                    <h1 className="title">CIPTEA</h1>
                    <p className="subtitle anim-typewriter">
                        Carteira de Identificação da Pessoa com Espectro Autista
                </p>
                </div>
            </div>
        </>
    )
}