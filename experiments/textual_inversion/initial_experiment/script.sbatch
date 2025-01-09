#!/bin/bash
#SBATCH --job-name=textual_inversion_initial_experiment             # Заместо aboba напишите ваше незвание эксперимента
#SBATCH --error=runs/textual_inversion_initial_experiment-%j.err    # Файл для вывода ошибок
#SBATCH --output=runs/textual_inversion_initial_experiment-%j.log   # Файл для вывода результатов
#SBATCH --gpus=1                     # Количество запрашиваемых гпу
#SBATCH --cpus-per-task=8            # Выполнение расчёта на 8 ядрах CPU
#SBATCH --time=3:00:00               # Максимальное время выполнения (чч:мм:сс), после его окончания програмаа просто сбрасывается
#SBATCH --constraint="[type_a|type_b|type_c]"   # Выбор, какие узлы использовать.
																		 # Узлы a, b и c - содержат v100, d без гпу, e - содержит a100, простым смертным недоступен (нужно писать Айбеку)

module load Python/Anaconda_v03.2023

source deactivate
source activate <имя окружения>

# дальше нужно написать список команд, которые нужно выполнить для эксперимента, к примеру:
# обучаем новый токен
python3 main.py --base configs/latent-diffusion/txt2img-1p4B-finetune.yaml
               -t
               --actual_resume /path/to/pretrained/model.ckpt
               -n initial_experiment
               --gpus 0,
               --data_root /path/to/directory/with/images
               --init_word figure
# генерируем изображения по этому токену
python3 scripts/txt2img.py --ddim_eta 0.0
                          --n_samples 8
                          --n_iter 2
                          --scale 10.0
                          --ddim_steps 50
                          --embedding_path /path/to/logs/trained_model/checkpoints/embeddings_gs-5049.pt
                          --ckpt_path /path/to/pretrained/model.ckpt
                          --prompt "a photo of *"