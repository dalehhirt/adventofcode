class StateMachine {
    [string]$CurrentState 
    [hashtable]$Transitions = @{}

    StateMachine([string]$initialState) {
        $this.CurrentState = $initialState
    }

    [void] AddTransition([string]$fromState, [string]$toState, [ScriptBlock]$action) {
        if (-not $this.Transitions.ContainsKey($fromState)) {
            $this.Transitions.Add($fromState, @{})
        }
        $this.Transitions[$fromState].Add($toState, $action)
    }

    [void] TriggerEvent([string]$triggerEvent) {
        $triggerTransitions = $this.Transitions[$this.CurrentState]
        if ($triggerTransitions.ContainsKey($triggerEvent)) {
            $action = $triggerTransitions[$triggerEvent]
            & $action 
            $this.CurrentState = $triggerEvent
        }
    }
}