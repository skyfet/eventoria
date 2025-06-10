
import React from 'react'
import ReactDOM from 'react-dom/client'
import { CssBaseline, Container, AppBar, Toolbar, Typography, Tabs, Tab, Box } from '@mui/material'
import { useState } from 'react'
import ObjectsPage from './pages/ObjectsPage'
import WorklogsPage from './pages/WorklogsPage'

const App = () => {
  const [tab, setTab] = useState(0)
  return (
    <>
      <CssBaseline />
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" sx={{ flexGrow: 1 }}>Maintenance MVP</Typography>
          <Tabs value={tab} onChange={(_, v) => setTab(v)} textColor="inherit">
            <Tab label="Objects" />
            <Tab label="Worklogs" />
          </Tabs>
        </Toolbar>
      </AppBar>
      <Container sx={{ mt: 4 }}>
        {tab === 0 && <ObjectsPage />}
        {tab === 1 && <WorklogsPage />}
      </Container>
    </>
  )
}

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(<App />)
