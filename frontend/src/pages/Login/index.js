import React, { useState } from 'react';
import { useBetween } from 'use-between';

// TODO: Fazer validação baseada na resposta da api para informar no form
import api from '../../services/api';
import { useLoadState } from '../../App';

export default function Login({ history }) {

    const { setLoading } = useBetween(useLoadState);
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    async function handleSubmit(e) {
        e.preventDefault();
        setLoading(true)
        const response = await api.post('/authenticate', {
            email,
            password
        })
        const { token } = response.data;
        localStorage.setItem('userToken', token);
        setLoading(false);
        history.push('/')
    }
    return (
        <>
            <p>Comece inserindo o seu endereço de <strong> e-mail </strong> e <strong>senha</strong > para adentrar à plataforma </p>
            <form onSubmit={handleSubmit}>
                <label htmlFor="email"> E-MAIL * </label>
                <input type="email"
                    id="email"
                    placeholder="Insira o seu endereço de e-mail"
                    value={email}
                    onChange={event => setEmail(event.target.value)}
                    required
                />
                <label htmlFor="password"> SENHA * </label>
                <input type="password"
                    id="password"
                    onChange={event => setPassword(event.target.value)}
                    placeholder="Insira sua senha"
                    required
                />
                <button className="btn" type="submit"> Entrar </button>
            </form>
        </>
    )
}