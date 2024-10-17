import React from 'react';
import './App.css';
import infraImage from './infrastructure.png'; // Importing the image

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Welcome to Our CI/CD Pipeline Project</h1>
        <p>
          This project implements a fully automated CI/CD pipeline using Terraform, Jenkins, Docker, 
          and Ansible, with cloud deployment.
        </p>

        <h2>Technologies Used</h2>
        <ul>
          <li>Jenkins</li>
          <li>Docker</li>
          <li>Ansible</li>
          <li>Terraform</li>
        </ul>

        {/* Infrastructure Image */}
        <h2>Infrastructure Overview</h2>
        <img src={infraImage} alt="Infrastructure Diagram" className="infra-image" />

        {/* Created By Section */}
        <footer>
          <h3>Created by: </h3>
          <p>Belal Elnady, Ahmed Abdelhares, Aya Alaa, Ahmed Darder, Mohamed Salama , Asmhan Salah</p>
        </footer>
      </header>
    </div>
  );
}

export default App;
