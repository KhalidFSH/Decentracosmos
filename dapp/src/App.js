import React, { Component } from 'react';
import { Jumbotron,  Nav, NavItem, NavLink, TabContent, TabPane,
          FormGroup, Form, Label, Input, Button, Col, Alert, Badge, Fade } from 'reactstrap';
          import './App.css';
import getWeb3 from "./utils/getWeb3";
import StarNotaryContract from "./contracts/StarNotary.json";


class App extends Component {
  constructor(props) {
    super(props);

    this.toggleTab = this.toggleTab.bind(this);
  
    this.state = {
      activeTab: '1',
      web3: null,
      accounts: null,
      contract: null,
      error: null,

      starName: "",
      starId: "",

      transfairToAddress: "",

      starLookedName:"",
      starLookedType:"",
      starLookedLevel:"",

      logs: []
    };
  }

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = StarNotaryContract.networks[networkId];
      const instance = new web3.eth.Contract(
        StarNotaryContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance });
    } catch (error) {
      this.setState({error: error.message || error});
      // Catch any errors for any of the above operations.
      Alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  toggleTab(tab) {
    if (this.state.activeTab !== tab) {
      this.setState({
        activeTab: tab,
        starId: "",
        starName: "",
        transfairToAddress: "",
        starLookedName:"",
        starLookedType:"",
        starLookedLevel:"",

      });
    }
  };

  handleIdChange(e) {
    this.setState({ starId: e.target.value });
  }

  handleNameChange(e) {
    this.setState({ starName: e.target.value });
  }
  handleAddressChange(e) {
    this.setState({ transfairToAddress: e.target.value });
  }

  handleCreateStar() {
    let starId = parseInt(this.state.starId)
    let StarName = (this.state.starName || "O9S-420")
    this.createStar(StarName, starId)
    this.setState({
      starId: "",
      starName: "",
    });
  }

  createStar= async(_name, _id) =>  {
    const { accounts, contract } = this.state;
    console.log(accounts[0])
    await contract.methods.createStar(_name, _id).send({ from: accounts[0] });
    this._addToLog("StarNotary.methods.createStar("+_name+", "+_id+").send()");
  }

  handleLookStar() {
    let starId = parseInt(this.state.starId)
    this.getStarInfo(starId)
    this.setState({
      starId: "",
    });
  }

  getStarInfo= async(_id) => {
    const { contract } = this.state;
    let starinfo = await contract.methods.lookUptokenIdToStarNameTypeLevel(_id).call();
    this._addToLog("StarNotary.methods.lookUptokenIdToStarName("+_id+").call() ====> returned ("+starinfo._name+","+starinfo._type+","+starinfo._level+")");
    console.log(starinfo)
    this.setState({
      starLookedName: starinfo._name,
      starLookedLevel: starinfo._level,
      starLookedType: starinfo._type
    })
  }

  handleTransfairStar() {
    let starId = parseInt(this.state.starId)
    let address = this.state.transfairToAddress
    this.transfairStar(starId, address)
    this.setState({
      starId: "",
      transfairToAddress: "",
    });
  }

  transfairStar= async(_id, _toAddress) => {
    const { accounts, contract } = this.state;
    await contract.methods.transfairAStar(_toAddress, _id).send({ from: accounts[0] });
    this._addToLog("StarNotary.methods.transfairAStar("+_toAddress+", "+_id+").send()");
  }

  _addToLog(txt) {
    this.state.logs.push(txt);
    this.setState({ logs: this.state.logs });
  }
  render() {
    if (!this.state.web3) {
      return <div>
        <Alert color="light">
        Loading Web3, accounts, and contract...
        </Alert>
        <Alert color="danger" isOpen={this.state.error}>
        {this.state.error}
        </Alert>
      </div>
    }
    return (
      <div className="App">
        <Jumbotron fluid >
          <h1 className="display-1">Decentracosmos</h1>
          <h1 className="display-1"><span role="img" aria-label='stars'> 🌌 </span></h1>
          <h1 className="display-5">A Star Notary Story</h1>
          <hr className="my-2" />
          <Nav tabs className="Tabs">
            <NavItem>
              <NavLink 
                active={this.state.activeTab === '1'}
                onClick={() => { this.toggleTab('1'); }}
              >
                Create Star
              </NavLink>
            </NavItem>
            <NavItem>
              <NavLink 
                active={this.state.activeTab === '2'}
                onClick={() => { this.toggleTab('2'); }}
              >
                Transfair Star
              </NavLink>
            </NavItem>
            <NavItem>
              <NavLink 
                active={this.state.activeTab === '3' }
                onClick={() => { this.toggleTab('3'); }}
              >
                Look for Star
              </NavLink>
            </NavItem>
            <NavItem>
              <NavLink 
                disabled
                active={this.state.activeTab === '4' }
                onClick={() => { this.toggleTab('4'); }}
              >
                Stars Marketplace
              </NavLink>
            </NavItem>
            <NavItem>
              <NavLink 
                disabled
                active={this.state.activeTab === '5' }
                onClick={() => { this.toggleTab('5'); }}
              >
                Exchange Stars
              </NavLink>
            </NavItem>
          </Nav>
          <TabContent activeTab={this.state.activeTab}>
            <TabPane tabId="1">
              <Form>
                <Label size="lg">Create New Star:</Label>
                <FormGroup row>
                  <Label for="starName" sm={2} size="lg" >Name</Label>
                  <Col sm={9} >
                    <Input 
                      placeholder="Write a name for your Ster" 
                      value={this.state.starName}
                      bsSize="lg" 
                      onChange={(e) => this.handleNameChange(e)}
                    />
                  </Col>
                </FormGroup>
                <FormGroup row>
                  <Label for="starId" sm={2} size="lg">ID</Label>
                  <Col sm={9}>
                    <Input 
                      type="number" 
                      placeholder="ID for your Star, most be number" 
                      value={this.state.starId}
                      bsSize="lg"
                      onChange={(e) => this.handleIdChange(e)}
                    />
                  </Col>
                </FormGroup>
                <Button outline 
                  color="primary" 
                  size="lg"
                  onClick={() => {this.handleCreateStar()}}>
                  Create Star</Button>
              </Form>
            </TabPane>
            <TabPane tabId="2">
              <Form>
                <Label size="lg">Transfair Star By Its ID:</Label>
                <p className="text-warning">You Should be the owner of this Star.</p>
                <FormGroup row>
                  <Label for="starId" sm={2} size="lg">StarID</Label>
                  <Col sm={9}>
                    <Input 
                      type="number" 
                      value={this.state.starId}
                      placeholder="ID for your Star, most be number" 
                      bsSize="lg"
                      onChange={(e) => this.handleIdChange(e)}
                    />
                  </Col>
                </FormGroup>
                <FormGroup row>
                  <Label for="starName" sm={2} size="lg">Address</Label>
                  <Col sm={9} >
                    <Input 
                      value={this.state.transfairToAddress}
                      placeholder="Write a destination valid ethereume address" 
                      bsSize="lg" 
                      onChange={(e) => this.handleAddressChange(e)}
                    />
                  </Col>
                </FormGroup>
                <Button outline 
                  color="primary" 
                  size="lg"
                  onClick={() => {this.handleTransfairStar()}}>
                  Transfair Star</Button>
              </Form>
            </TabPane>
            <TabPane tabId="3">
              <Form>
                <Label size="lg">Look Up Star Info By Its ID:</Label>
                <FormGroup row>
                  <Label for="starId" sm={2} size="lg">StarID</Label>
                  <Col sm={9}>
                    <Input 
                      type="number" 
                      value={this.state.starId}
                      placeholder="ID for your Star, most be number" 
                      onChange={(e) => this.handleIdChange(e)}
                      bsSize="lg"
                    />
                  </Col>
                </FormGroup>
                <Button outline 
                  color="primary" 
                  size="lg"
                  onClick={() => {this.handleLookStar()}}>Look Up</Button>
              </Form>
              <Fade in={this.state.starLookedName !== ""} tag="h3" className="mt-3">
                <Alert color="success">
                  Star Name: <p className="text-muted">{this.state.starLookedName}</p>Type: {this.state.starLookedType}  ||  Level: {this.state.starLookedLevel}
                </Alert>      
              </Fade>
            </TabPane>
            <TabPane tabId="4">

            </TabPane>
            <TabPane tabId="5">

            </TabPane>
          </TabContent>
        </Jumbotron>
        <div className="logs">
          {
            this.state.logs.map((item, i) => 
              <div>
              <p key={i}>{item}   
                <Badge color="success" pill>
                  Success
                </Badge>
                </p>
              </div>
            )
          }
        </div>
      </div>
    );
  }
}

export default App;
