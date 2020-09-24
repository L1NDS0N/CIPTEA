import React from 'react';
import { FiGithub, FiCamera } from 'react-icons/fi';
import './styles.css';

export default function MainFooter() {
    return (
        <>
            <footer>
                <p className="devCredits" >
                    Developed and distruted by <a
                        href="https://github.com/l1nds0n/"
                        target="_blank"
                        rel="noopener noreferrer">
                        <strong><FiGithub /> L1NDS0N  </strong>
                    © 2020
                    </a>
                </p>
                <p className="imageCredits" >
                    Fundo por <a
                        href="https://wendelljefferson.com.br/"
                        target="_blank"
                        rel="noopener noreferrer" >
                        <strong> <FiCamera/> Wendell Jefferson  </strong>
                    </a>
                </p>
            </footer>
        </>
    )
}