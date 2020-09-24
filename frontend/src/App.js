import React, { useState } from 'react';
import './App.css'
import Routes from './routes';
import MainFooter from './components/MainFooter'
import MainHeader from './components/MainHeader'

function App() {

    return (
        <div className="container">

            <MainHeader />

            <div className="content">

                <Routes />

            </div>

            <MainFooter />

        </div>
    );
}

export default App;

// Implementação de constantes globais para uso do Hook 'useBetween' para compartilhar o estado entre componentes,
// E retornar como animação na logo principal 
export const useLoadState = () => {
    const [loading, setLoading] = useState(true);
    return { loading, setLoading };
}