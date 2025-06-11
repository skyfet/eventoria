
import React, { useState, useEffect } from 'react'
import { TextField, Button, List, ListItem, ListItemText, Paper, Stack } from '@mui/material'

const API_BASE = import.meta.env.VITE_API_BASE || 'http://localhost:8000'

interface Log {
  id: number
  description: string
  work_order_id: number
  performer_id: number
  performed_at: string
}

export default function WorklogsPage() {
  const [logs, setLogs] = useState<Log[]>([])
  const [workOrderId, setWorkOrderId] = useState('')
  const [performerId, setPerformerId] = useState('')
  const [description, setDescription] = useState('')

  const load = async () => {
    const l = await fetch(`${API_BASE}/worklogs`).then(r => r.json())
    setLogs(l)
  }

  useEffect(()=>{load()},[])

  const add = async () => {
    if(!workOrderId || !performerId) return
    await fetch(`${API_BASE}/worklogs`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        work_order_id: Number(workOrderId),
        performer_id: Number(performerId),
        description,
      }),
    })
    setDescription('')
    setWorkOrderId('')
    setPerformerId('')
    load()
  }

  return (
    <Paper sx={{p:3}}>
      <Stack spacing={2}>
        <TextField label="Work Order ID" value={workOrderId} onChange={e=>setWorkOrderId(e.target.value)} />
        <TextField label="Performer ID" value={performerId} onChange={e=>setPerformerId(e.target.value)} />
        <TextField label="Description" value={description} onChange={e=>setDescription(e.target.value)}/>
        <Button variant="contained" onClick={add}>Add</Button>
        <List dense>
          {logs.map(l=>(
            <ListItem key={l.id}>
              <ListItemText
                primary={l.description}
                secondary={`WO ${l.work_order_id} by ${l.performer_id} – ` + new Date(l.performed_at).toLocaleString()}
              />
            </ListItem>
          ))}
        </List>
      </Stack>
    </Paper>
  )
}
