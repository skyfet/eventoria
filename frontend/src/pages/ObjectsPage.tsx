
import React, { useState, useEffect } from 'react'
import { TextField, Button, List, ListItem, ListItemText, Paper, Stack } from '@mui/material'

interface Obj { id: number; name: string; address: string }

export default function ObjectsPage() {
  const [objects, setObjects] = useState<Obj[]>([])
  const [name, setName] = useState('')
  const [address, setAddress] = useState('')

  const load = async () => {
    const r = await fetch('http://localhost:8000/objects')
    setObjects(await r.json())
  }

  useEffect(() => { load() }, [])

  const add = async () => {
    await fetch('http://localhost:8000/objects', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, address })
    })
    setName('')
    setAddress('')
    load()
  }

  return (
    <Paper sx={{ p:3 }}>
      <Stack spacing={2}>
        <TextField label="Name" value={name} onChange={e=>setName(e.target.value)} />
        <TextField label="Address" value={address} onChange={e=>setAddress(e.target.value)} />
        <Button variant="contained" onClick={add}>Add</Button>
        <List dense>
          {objects.map(o=>(<ListItem key={o.id}><ListItemText primary={o.name} secondary={o.address}/></ListItem>))}
        </List>
      </Stack>
    </Paper>
  )
}
