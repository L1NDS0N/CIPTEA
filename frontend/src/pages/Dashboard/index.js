import React, { useEffect, useState } from 'react';
import { useBetween } from 'use-between';
import { Link } from 'react-router-dom';
import { FiSearch, FiUserPlus } from 'react-icons/fi';

import { useLoadState } from '../../App';
import api from '../../services/api';
import './styles.css';

export default function Dashboard() {
    const [registros, setRegistros] = useState([]);
    const [search, setSearch] = useState('');
    const [filteredSearch, setFilteredSearch] = useState([]);
    // Atenção para chaves abaixo porque é oriundo do Hook useBetween
    const { loading, setLoading } = useBetween(useLoadState);

    useEffect(() => {
        async function carregarRegistros() {
            setLoading(true);
            const token = localStorage.getItem('userToken');
            const response = await api.get('/carteiras', {
                headers: { 'Authorization': 'Bearer ' + token }
            });
            setRegistros(response.data)
            setLoading(false);
        }
        carregarRegistros();
    }, [setLoading]);

    useEffect(() => {
        setFilteredSearch(
            registros.filter(registro => {
                if (registro.nomeTitular === undefined) {
                    return <p>erro</p>
                }
                if (!isNaN(search)) {
                    return registro.cpfTitular.toLowerCase().includes(search.toLowerCase())
                }
                return registro.nomeTitular.toLowerCase().includes(search.toLowerCase())
            })
        )

    }, [search, registros])

    if (loading) {
        return (
            <ul className="lista-registros">
                Carregando carteirinhas...
            </ul>
        )
    }

    return (
        <>
            <Link to={'/new'}>
                <label className="create-box" htmlFor="create-txt" title="Criar nova carteira">
                    <button
                        id="create-txt"
                        className="create-txt"
                    />
                    <FiUserPlus className="create-btn" />
                </label>
            </Link>

            <label className="search-box" htmlFor="search-txt">
                <input
                    id="search-txt"
                    type="text"
                    placeholder="Pesquisar por nome ou cpf"
                    className="search-txt"
                    onChange={e => setSearch(e.target.value)} />
                <FiSearch className="search-btn" />
            </label>

            <ul className="lista-registros">
                {filteredSearch.map(registro => (
                    <Link key={registro.id} to={`/card/${registro.id}`}>
                        <li>
                            {/* ver configuração de upload de imagens */}
                            <header style={{ backgroundImage: `url(http://localhost:3333/files/${registro.fotoRostoPath})` }}></header>
                            <strong>{
                                registro.nomeTitular.trim().split(' ').slice(0, 1) +
                                " " + registro.nomeTitular.trim().split(' ').slice(-1)
                            }</strong>
                            <span>{registro.cpfTitular ? `${registro.cpfTitular}` : `${registro.rgTitular}`}</span>
                        </li>
                    </Link>
                ))}
            </ul>

            <Link to="/new">
                <button className="btn">Criar nova carteira</button>
            </Link>

        </>
    )
}