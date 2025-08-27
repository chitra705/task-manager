document.addEventListener('DOMContentLoaded', function() {
  // Function to update charts based on filter selection
  function updateChart(chartId, filterId, endpoint) {
    const filter = document.getElementById(filterId);
    filter.addEventListener('change', function() {
      const value = filter.value;
      console.log(`Updating ${chartId} with filter: ${value}`);
      fetch(`/dashboard/${endpoint}?filter=${value}`)
        .then(response => response.json())
        .then(data => {
          // Update the chart with the new data
          Chartkick.charts[chartId].updateData(data);
        });
    });
  }

  updateChart('tasksCreatedChart', 'filter_tasks_created', 'tasks_created_per_day');
  updateChart('taskStatusChart', 'filter_task_status', 'task_status_distribution');
  updateChart('completionTimeChart', 'filter_completion_time', 'completion_time_per_week');
  updateChart('assignedTasksChart', 'filter_assigned_tasks', 'tasks_assigned_to_members');
});
