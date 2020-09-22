import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { FiSearch, FiUserPlus } from 'react-icons/fi';

import api from '../../services/api';
import './styles.css';

export default function Dashboard() {
    const [registros, setRegistros] = useState([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState('');
    const [filteredSearch, setFilteredSearch] = useState([]);

    useEffect(() => {
        async function carregarRegistros() {
            const token = localStorage.getItem('userToken');
            const response = await api.get('/carteiras', {
                headers: { 'Authorization': 'Bearer ' + token }
            });
            setRegistros(response.data)
            setLoading(false);
        }
        carregarRegistros();
    }, []);

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
                <li>Carregando registros...</li>
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
                            {/* <header style={{ backgroundImage: 'url(https://blog.influx.com.br/storage/app/uploads/public/67d/18f/2fd/67d18f2fdf601e40e21e8dc4e70247ca62c6ac83.jpg)'}}></header> */}
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