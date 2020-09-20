import React from 'react';
import './App.css'
import Routes from './routes';
import MainFooter from './components/MainFooter'
import MainHeader from './components/MainHeader'

function App() { 

    return (     
        <div className="container">        

        <MainHeader/>

        <div className="content">
            
            <Routes />
        
        </div> 

            <MainFooter/>
            
        </div>
    );
    }

export default App;