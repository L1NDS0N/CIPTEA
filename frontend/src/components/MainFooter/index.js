import React from 'react';
import './styles.css';

export default function MainFooter(){
    return(
        <>
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
                    Fundo por <a 
                        href="https://wendelljefferson.com.br/"
                        target="_blank"
                        rel="noopener noreferrer" >
                <strong> Wendell Jefferson  </strong>
                    </a> 
                    </p> 
            </footer>
        </>
    )
}