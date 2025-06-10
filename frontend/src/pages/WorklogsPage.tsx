
import React, { useState, useEffect } from 'react'
import { TextField, Button, List, ListItem, ListItemText, Paper, Stack, MenuItem, Select } from '@mui/material'

interface Obj { id: number; name: string }
interface Log { id: number; description: string; object_id: number; performed_at: string }

export default function WorklogsPage() {
  const [objects, setObjects] = useState<Obj[]>([])
  const [logs, setLogs] = useState<Log[]>([])
  const [objectId, setObjectId] = useState<number | ''>('')
  const [description, setDescription] = useState('')

  const load = async () => {
    const [o, l] = await Promise.all([
      fetch('http://localhost:8000/objects').then(r=>r.json()),
      fetch('http://localhost:8000/worklogs').then(r=>r.json())
    ])
    setObjects(o); setLogs(l)
  }

  useEffect(()=>{load()},[])

  const add = async () => {
    if(!objectId) return
    await fetch('http://localhost:8000/worklogs', {
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body: JSON.stringify({object_id: objectId, description })
    })
    setDescription(''); setObjectId(''); load()
  }

  const objName = (id:number)=>objects.find(o=>o.id===id)?.name || id

  return (
    <Paper sx={{p:3}}>
      <Stack spacing={2}>
        <Select displayEmpty value={objectId} onChange={e=>setObjectId(e.target.value as any)}>
          <MenuItem value=''><em>Select Object</em></MenuItem>
          {objects.map(o=><MenuItem key={o.id} value={o.id}>{o.name}</MenuItem>)}
        </Select>
        <TextField label="Description" value={description} onChange={e=>setDescription(e.target.value)}/>
        <Button variant="contained" onClick={add}>Add</Button>
        <List dense>
          {logs.map(l=>(<ListItem key={l.id}>
            <ListItemText primary={l.description} secondary={objName(l.object_id)+' – '+new Date(l.performed_at).toLocaleString()}/>
          </ListItem>))}
        </List>
      </Stack>
    </Paper>
  )
}
