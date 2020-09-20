import React, { useState } from 'react';

// import MainHeader from '../../components/MainHeader'

import api from '../../services/api';

export default function Login({ history }){
    
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    async function handleSubmit(e) {
        e.preventDefault();

        const response = await api.post('/authenticate', {
            email,
            password
        })
        const { token } = response.data;

        localStorage.setItem('userToken', token);

        history.push('/')
    }
    return (
        <>
        {/* <MainHeader/> */}
            <p>Comece inserindo o seu endereço de <strong> e-mail </strong> e <strong>senha</strong > para adentrar à plataforma </p>
            <form onSubmit={ handleSubmit }>
                <label htmlFor="email"> E-MAIL * </label> 
                <input type="email"
                    id="email"
                    placeholder="Insira o seu endereço de e-mail"
                    value={ email }
                    onChange={ event => setEmail(event.target.value) }
                    required
                /> 
                <label htmlFor="password"> SENHA * </label> 
                <input type="password" 
                    id="password"
                    onChange={ event => setPassword(event.target.value) }
                    placeholder="Insira sua senha" 
                    required
                />
                <button className="btn" type="submit"> Entrar </button> 
            </form>
        </>
    )
}