# https://github.com/facebookresearch/clevr-dataset-gen/issues/14#issuecomment-484300688

import argparse, os, json, random
from collections import defaultdict

parser = argparse.ArgumentParser()
parser.add_argument('--input_questions_file',  default='../clevr-output/CLEVR_questions.json')
parser.add_argument('--output_questions_file', default='../clevr-output/CLEVR_fixed_questions.json')

def main(args):
    # Load questions
    with open(args.input_questions_file, 'r') as f:
        question_data = json.load(f)
        info = question_data['info']
        questions = question_data['questions']
    print('Read %d questions from disk' % len(questions))
    for q in questions:
        # Rename 'type' to 'function'
        programs = q['program']
        for p in programs:
            p['function'] = p.pop('type')
        answer = q['answer']
        # Stringyfy 'answer'
        if answer is True:
            answer = 'yes'
        elif answer is False:
            answer = 'no'
        else:
            answer = str(answer)
        q['answer'] = answer

    # Dump new dict
    with open(args.output_questions_file, 'w') as f:
        print('Writing output to %s' % args.output_questions_file)
        json.dump({
            'info': info,
            'questions': questions,
        }, f)

if __name__ == '__main__':
  main(parser.parse_args())
