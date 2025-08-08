/**
 * Unit tests for API functions
 */

const { mockFetchResponse, mockFetchError } = require('./test-utils.js');

describe('API Functions', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Exercise API', () => {
    test('should fetch exercises for tk4 version', async () => {
      const mockExercises = [
        { id: '1', title: 'Exercise 1', section: 'beginner' },
        { id: '2', title: 'Exercise 2', section: 'intermediate' }
      ];

      global.fetch = jest.fn().mockResolvedValue({
        ok: true,
        json: () => Promise.resolve({ exercises: mockExercises })
      });

      const response = await fetch('/api/exercises/tk4');
      const data = await response.json();

      expect(fetch).toHaveBeenCalledWith('/api/exercises/tk4');
      expect(data.exercises).toEqual(mockExercises);
    });

    // TK4-only: removed TK5 fetch test

    test('should handle exercise fetch errors', async () => {
      global.fetch = jest.fn().mockRejectedValue(new Error('Network error'));

      await expect(fetch('/api/exercises/tk4')).rejects.toThrow('Network error');
    });

    test('should handle non-ok responses', async () => {
      global.fetch = jest.fn().mockResolvedValue({
        ok: false,
        status: 404,
        statusText: 'Not Found'
      });

      const response = await fetch('/api/exercises/tk4');
      expect(response.ok).toBe(false);
      expect(response.status).toBe(404);
    });
  });

  describe('Individual Exercise API', () => {
    test('should fetch individual exercise', async () => {
      const mockExercise = {
        id: 'exercise-1',
        title: 'Test Exercise',
        content: 'Exercise content here',
        rawContent: 'Estimated Time: 15-20 min\n\nExercise content here'
      };

      global.fetch = jest.fn().mockResolvedValue({
        ok: true,
        json: () => Promise.resolve(mockExercise)
      });

      const response = await fetch('/api/exercise/tk4/exercise-1');
      const data = await response.json();

      expect(fetch).toHaveBeenCalledWith('/api/exercise/tk4/exercise-1');
      expect(data).toEqual(mockExercise);
    });

    test('should handle exercise not found', async () => {
      global.fetch = jest.fn().mockResolvedValue({
        ok: false,
        status: 404,
        statusText: 'Not Found'
      });

      const response = await fetch('/api/exercise/tk4/nonexistent');
      expect(response.ok).toBe(false);
      expect(response.status).toBe(404);
    });
  });

  describe('Progress API', () => {
    test('should save progress to server', async () => {
      const progressData = {
        userId: 'testuser',
        completed: ['exercise-1'],
        currentExercise: 'exercise-2',
        lastAccessed: new Date().toISOString()
      };

      global.fetch = jest.fn().mockResolvedValue({
        ok: true,
        json: () => Promise.resolve({ success: true })
      });

      const response = await fetch('/api/progress', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(progressData)
      });

      expect(fetch).toHaveBeenCalledWith('/api/progress', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(progressData)
      });
    });

    test('should load progress from server', async () => {
      const mockProgress = {
        completed: ['exercise-1'],
        currentExercise: 'exercise-2',
        lastAccessed: new Date().toISOString()
      };

      global.fetch = jest.fn().mockResolvedValue({
        ok: true,
        json: () => Promise.resolve(mockProgress)
      });

      const response = await fetch('/api/progress/testuser');
      const data = await response.json();

      expect(fetch).toHaveBeenCalledWith('/api/progress/testuser');
      expect(data).toEqual(mockProgress);
    });
  });

  describe('Error Handling', () => {
    test('should handle network timeouts', async () => {
      global.fetch = jest.fn().mockImplementation(() => {
        return new Promise((_, reject) => {
          setTimeout(() => reject(new Error('Timeout')), 100);
        });
      });

      await expect(fetch('/api/exercises/tk4')).rejects.toThrow('Timeout');
    });

    test('should handle malformed JSON responses', async () => {
      global.fetch = jest.fn().mockResolvedValue({
        ok: true,
        json: () => Promise.reject(new Error('Invalid JSON'))
      });

      const response = await fetch('/api/exercises/tk4');
      await expect(response.json()).rejects.toThrow('Invalid JSON');
    });

    test('should handle server errors', async () => {
      global.fetch = jest.fn().mockResolvedValue({
        ok: false,
        status: 500,
        statusText: 'Internal Server Error'
      });

      const response = await fetch('/api/exercises/tk4');
      expect(response.ok).toBe(false);
      expect(response.status).toBe(500);
    });
  });

  describe('Request Validation', () => {
    test('should validate exercise ID format', () => {
      const isValidExerciseId = (id) => {
        return typeof id === 'string' && 
               id.length > 0 && 
               /^[a-zA-Z0-9-_]+$/.test(id);
      };

      expect(isValidExerciseId('exercise-1')).toBe(true);
      // TK4-only: removed TK5-specific ID assertion
      expect(isValidExerciseId('')).toBe(false);
      expect(isValidExerciseId('exercise<1>')).toBe(false);
      expect(isValidExerciseId(null)).toBe(false);
    });

    test('should validate version parameter', () => {
      const isValidVersion = (version) => {
        return ['tk4'].includes(version);
      };

      expect(isValidVersion('tk4')).toBe(true);
      // TK4-only: removed TK5 version assertion
      expect(isValidVersion('tk3')).toBe(false);
      expect(isValidVersion('')).toBe(false);
      expect(isValidVersion(null)).toBe(false);
    });

    test('should validate user ID format', () => {
      const isValidUserId = (userId) => {
        return typeof userId === 'string' && 
               userId.length >= 3 && 
               userId.length <= 50 &&
               /^[a-zA-Z0-9-_]+$/.test(userId);
      };

      expect(isValidUserId('testuser')).toBe(true);
      expect(isValidUserId('user-123')).toBe(true);
      expect(isValidUserId('ab')).toBe(false); // too short
      expect(isValidUserId('a'.repeat(51))).toBe(false); // too long
      expect(isValidUserId('user<123>')).toBe(false); // invalid chars
    });
  });

  describe('Response Processing', () => {
    test('should process exercise list response', () => {
      const processExerciseResponse = (data) => {
        if (!data || !data.exercises) {
          throw new Error('Invalid response format');
        }
        return data.exercises.map(ex => ({
          ...ex,
          section: ex.section || 'beginner',
          order: ex.order || 0
        }));
      };

      const validResponse = {
        exercises: [
          { id: '1', title: 'Exercise 1' },
          { id: '2', title: 'Exercise 2', section: 'intermediate', order: 2 }
        ]
      };

      const processed = processExerciseResponse(validResponse);
      expect(processed).toHaveLength(2);
      expect(processed[0].section).toBe('beginner');
      expect(processed[0].order).toBe(0);
      expect(processed[1].section).toBe('intermediate');
      expect(processed[1].order).toBe(2);
    });

    test('should handle invalid response format', () => {
      const processExerciseResponse = (data) => {
        if (!data || !data.exercises) {
          throw new Error('Invalid response format');
        }
        return data.exercises;
      };

      expect(() => processExerciseResponse(null)).toThrow('Invalid response format');
      expect(() => processExerciseResponse({})).toThrow('Invalid response format');
      expect(() => processExerciseResponse({ other: 'data' })).toThrow('Invalid response format');
    });
  });
}); 