import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import api from '../../services/api';

import './styles.css';

export default function Dashboard(){
    const [registros, setRegistros] = useState([]);

    useEffect(() => {
        async function carregarRegistros(){
            const token = localStorage.getItem('userToken');
            const response = await api.get('/carteiras', {
                headers: { 'Authorization': 'Bearer ' + token }
            });
            setRegistros(response.data)
        }
        carregarRegistros();
    }, []);
    return (
        <>
            <ul className="lista-registros">
               { registros.map(registro => (
                   <li key={registro.id}>
                        {/* ver configuração de upload de imagens */}
                       <header style={{ backgroundImage: 'url(https://blog.influx.com.br/storage/app/uploads/public/67d/18f/2fd/67d18f2fdf601e40e21e8dc4e70247ca62c6ac83.jpg)'}}></header>
                       <strong>{registro.nomeTitular}</strong>
                        <span>{registro.cpfTitular ? `${registro.cpfTitular}` : `${registro.rgTitular}`}</span>
                   </li>
               ))}
            </ul>
           
            <Link to="/new">
            <button className="btn">Criar nova carteira</button>
            </Link>
         
        </> 
    )
}