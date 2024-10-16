import logo from './logo.svg';
import cat from './exhuasted.jpg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1 className="center">The sad reality of the DevOps</h1>
        <p className="center">You have to do just about everything, and somehow you do nothing at the same time</p>
        <img src={cat} style={{"margin-top" : "50vh"}} alt="cat" />
      </header>
    </div>
  );
}

export default App;
