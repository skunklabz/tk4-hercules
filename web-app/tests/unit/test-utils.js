/**
 * Test utilities for TKX-Hercules LMS unit tests
 */

// Mock DOM elements
const createMockElement = (id, className = '', innerHTML = '') => {
  const element = document.createElement('div');
  element.id = id;
  element.className = className;
  element.innerHTML = innerHTML;
  return element;
};

// Mock exercise data
const mockExercises = [
  {
    id: 'exercise-1',
    title: 'First Exercise',
    section: 'beginner',
    order: 1,
    content: 'This is the first exercise content.',
    rawContent: 'Estimated Time: 15-20 min\n\nThis is the first exercise content.'
  },
  {
    id: 'exercise-2',
    title: 'Second Exercise',
    section: 'intermediate',
    order: 2,
    content: 'This is the second exercise content.',
    rawContent: 'Estimated Time: 20-25 min\n\nThis is the second exercise content.'
  },
  {
    id: 'exercise-3',
    title: 'Third Exercise',
    section: 'advanced',
    order: 3,
    content: 'This is the third exercise content.',
    rawContent: 'Estimated Time: 30-35 min\n\nThis is the third exercise content.'
  }
];

// Mock progress data
const mockProgress = {
  completed: ['exercise-1'],
  currentExercise: 'exercise-2',
  lastAccessed: new Date().toISOString()
};

// Setup DOM for testing
const setupDOM = () => {
  // Create main app container
  const app = createMockElement('app', 'app');
  document.body.appendChild(app);

  // Create sidebar elements
  const sidebar = createMockElement('sidebar', 'sidebar');
  const sidebarToggle = createMockElement('sidebar-toggle', 'sidebar-toggle');
  const progressFill = createMockElement('progress-fill', 'progress-fill');
  const progressText = createMockElement('progress-text', 'progress-text', '0% Complete');
  
  sidebar.appendChild(sidebarToggle);
  sidebar.appendChild(progressFill);
  sidebar.appendChild(progressText);
  
  // Create exercise sections
  const beginnerExercises = createMockElement('beginner-exercises', 'exercise-list');
  const intermediateExercises = createMockElement('intermediate-exercises', 'exercise-list');
  const advancedExercises = createMockElement('advanced-exercises', 'exercise-list');
  const expertExercises = createMockElement('expert-exercises', 'exercise-list');
  
  sidebar.appendChild(beginnerExercises);
  sidebar.appendChild(intermediateExercises);
  sidebar.appendChild(advancedExercises);
  sidebar.appendChild(expertExercises);
  
  app.appendChild(sidebar);

  // Create main panel elements
  const mainPanel = createMockElement('main-panel', 'main-panel');
  const welcomeScreen = createMockElement('welcome-screen', 'welcome-screen');
  const exerciseView = createMockElement('exercise-view', 'exercise-view');
  const exerciseTitle = createMockElement('exercise-title', 'exercise-title');
  const exerciseText = createMockElement('exercise-text', 'exercise-text');
  const exerciseLevel = createMockElement('exercise-level', 'exercise-level');
  const exerciseTime = createMockElement('exercise-time', 'exercise-time');
  
  exerciseView.appendChild(exerciseTitle);
  exerciseView.appendChild(exerciseText);
  exerciseView.appendChild(exerciseLevel);
  exerciseView.appendChild(exerciseTime);
  
  mainPanel.appendChild(welcomeScreen);
  mainPanel.appendChild(exerciseView);
  app.appendChild(mainPanel);

  // Create header elements
  const header = createMockElement('header', 'header');
  const userId = createMockElement('user-id', 'user-id', 'Guest');
  const versionSelect = createMockElement('version-select', 'version-select');
  const loginBtn = createMockElement('login-btn', 'login-btn');
  
  header.appendChild(userId);
  header.appendChild(versionSelect);
  header.appendChild(loginBtn);
  app.appendChild(header);

  // Create modal elements
  const loginModal = createMockElement('login-modal', 'modal');
  const userInput = createMockElement('user-id-input', 'user-id-input');
  const loginSubmit = createMockElement('login-submit', 'login-submit');
  const loginCancel = createMockElement('login-cancel', 'login-cancel');
  
  loginModal.appendChild(userInput);
  loginModal.appendChild(loginSubmit);
  loginModal.appendChild(loginCancel);
  app.appendChild(loginModal);

  // Create action buttons
  const startLearning = createMockElement('start-learning', 'btn btn-primary');
  const markComplete = createMockElement('mark-complete', 'btn btn-secondary');
  const backToWelcome = createMockElement('back-to-welcome', 'btn btn-back');
  
  welcomeScreen.appendChild(startLearning);
  exerciseView.appendChild(markComplete);
  exerciseView.appendChild(backToWelcome);
};

// Cleanup DOM after tests
const cleanupDOM = () => {
  document.body.innerHTML = '';
};

// Mock fetch responses
const mockFetchResponse = (data, ok = true) => {
  global.fetch.mockResolvedValue({
    ok,
    json: () => Promise.resolve(data)
  });
};

// Mock fetch error
const mockFetchError = (error = 'Network error') => {
  global.fetch.mockRejectedValue(new Error(error));
};

module.exports = {
  createMockElement,
  mockExercises,
  mockProgress,
  setupDOM,
  cleanupDOM,
  mockFetchResponse,
  mockFetchError
}; 