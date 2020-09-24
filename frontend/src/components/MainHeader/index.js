import React from 'react';

import logo from '../../assets/logo.svg'
import './styles.css';
// Implementação da animação do logo enquanto está carregando
import { useBetween } from 'use-between';
import { useLoadState } from '../../App';

export default function MainHeader() {

    const { loading } = useBetween(useLoadState);

    return (
        <>
            <div id="MainHeader">
                <div id="MHContent">
                    <a href="/">
                        <img
                            src={logo}
                            id="logo"
                            alt="CipteaLogo" 
                            style={ loading ? { animation: "logo-danca 1s ease-in-out infinite alternate" } : {}}
                            />
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