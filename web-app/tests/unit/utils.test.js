/**
 * Unit tests for utility functions
 */

const { setupDOM, cleanupDOM, mockExercises, mockProgress, mockFetchResponse, mockFetchError } = require('./test-utils.js');

describe('Utility Functions', () => {
  describe('Progress Calculation', () => {
    test('should calculate progress percentage correctly', () => {
      const calculateProgress = (completed, total) => {
        return total > 0 ? Math.round((completed / total) * 100) : 0;
      };

      expect(calculateProgress(0, 10)).toBe(0);
      expect(calculateProgress(5, 10)).toBe(50);
      expect(calculateProgress(10, 10)).toBe(100);
      expect(calculateProgress(0, 0)).toBe(0);
    });

    test('should handle edge cases', () => {
      const calculateProgress = (completed, total) => {
        return total > 0 ? Math.round((completed / total) * 100) : 0;
      };

      expect(calculateProgress(-1, 10)).toBe(-10);
      expect(calculateProgress(15, 10)).toBe(150);
    });
  });

  describe('Exercise Filtering', () => {
    test('should filter exercises by section', () => {
      const exercises = [
        { id: '1', section: 'beginner', title: 'Exercise 1' },
        { id: '2', section: 'intermediate', title: 'Exercise 2' },
        { id: '3', section: 'beginner', title: 'Exercise 3' },
        { id: '4', section: 'advanced', title: 'Exercise 4' }
      ];

      const filterBySection = (exercises, section) => {
        return exercises.filter(ex => ex.section === section);
      };

      const beginnerExercises = filterBySection(exercises, 'beginner');
      const intermediateExercises = filterBySection(exercises, 'intermediate');
      const advancedExercises = filterBySection(exercises, 'advanced');

      expect(beginnerExercises).toHaveLength(2);
      expect(intermediateExercises).toHaveLength(1);
      expect(advancedExercises).toHaveLength(1);
    });
  });

  describe('Data Validation', () => {
    test('should validate exercise data structure', () => {
      const isValidExercise = (exercise) => {
        if (!exercise) return false;
        return typeof exercise.id === 'string' &&
               typeof exercise.title === 'string' &&
               typeof exercise.section === 'string' &&
               typeof exercise.order === 'number';
      };

      const validExercise = {
        id: 'exercise-1',
        title: 'Test Exercise',
        section: 'beginner',
        order: 1
      };

      const invalidExercise = {
        id: 'exercise-1',
        title: 'Test Exercise'
        // Missing required fields
      };

      expect(isValidExercise(validExercise)).toBe(true);
      expect(isValidExercise(invalidExercise)).toBe(false);
      expect(isValidExercise(null)).toBe(false);
      expect(isValidExercise(undefined)).toBe(false);
    });

    test('should validate progress data structure', () => {
      const isValidProgress = (progress) => {
        return progress &&
               Array.isArray(progress.completed) &&
               typeof progress.currentExercise === 'string' &&
               typeof progress.lastAccessed === 'string';
      };

      const validProgress = {
        completed: ['exercise-1'],
        currentExercise: 'exercise-2',
        lastAccessed: new Date().toISOString()
      };

      const invalidProgress = {
        completed: 'not-an-array'
      };

      expect(isValidProgress(validProgress)).toBe(true);
      expect(isValidProgress(invalidProgress)).toBe(false);
    });
  });

  describe('String Utilities', () => {
    test('should extract time estimate from content', () => {
      const extractTimeEstimate = (content) => {
        const timeMatch = content.match(/Estimated Time.*?(\d+-\d+)/);
        return timeMatch ? timeMatch[1] : null;
      };

      const contentWithTime = 'Estimated Time: 15-20 min\n\nExercise content here.';
      const contentWithoutTime = 'Exercise content without time estimate.';

      expect(extractTimeEstimate(contentWithTime)).toBe('15-20');
      expect(extractTimeEstimate(contentWithoutTime)).toBe(null);
    });

    test('should sanitize user input', () => {
      const sanitizeInput = (input) => {
        return input ? input.trim().replace(/[<>]/g, '') : '';
      };

      expect(sanitizeInput('  test user  ')).toBe('test user');
      expect(sanitizeInput('<script>alert("xss")</script>')).toBe('scriptalert("xss")/script');
      expect(sanitizeInput('')).toBe('');
      expect(sanitizeInput(null)).toBe('');
    });
  });

  describe('Date Utilities', () => {
    test('should format dates correctly', () => {
      const formatDate = (dateString) => {
        const date = new Date(dateString);
        return date.toLocaleDateString();
      };

      const testDate = '2024-01-15T10:30:00Z';
      const formatted = formatDate(testDate);

      expect(typeof formatted).toBe('string');
      expect(formatted).toMatch(/\d+\/\d+\/\d+/);
    });

    test('should check if date is recent', () => {
      const isRecent = (dateString, days = 7) => {
        const date = new Date(dateString);
        const now = new Date();
        const diffTime = Math.abs(now - date);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays <= days;
      };

      const recentDate = new Date().toISOString();
      const oldDate = '2020-01-01T00:00:00Z';

      expect(isRecent(recentDate)).toBe(true);
      expect(isRecent(oldDate)).toBe(false);
    });
  });

  describe('Array Utilities', () => {
    test('should remove duplicates from arrays', () => {
      const removeDuplicates = (array) => {
        return [...new Set(array)];
      };

      const arrayWithDuplicates = [1, 2, 2, 3, 3, 4];
      const uniqueArray = removeDuplicates(arrayWithDuplicates);

      expect(uniqueArray).toEqual([1, 2, 3, 4]);
      expect(uniqueArray).toHaveLength(4);
    });

    test('should sort exercises by order', () => {
      const sortByOrder = (exercises) => {
        return exercises.sort((a, b) => a.order - b.order);
      };

      const exercises = [
        { id: '3', order: 3, title: 'Third' },
        { id: '1', order: 1, title: 'First' },
        { id: '2', order: 2, title: 'Second' }
      ];

      const sorted = sortByOrder(exercises);

      expect(sorted[0].order).toBe(1);
      expect(sorted[1].order).toBe(2);
      expect(sorted[2].order).toBe(3);
    });
  });
}); 